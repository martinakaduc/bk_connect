import numpy as np
import tensorflow as tf
from scipy import misc

import detect_face


class PreProcessor():
    def __init__(self):
        with tf.Graph().as_default():
            gpu_options = tf.GPUOptions(allow_growth=True)
            self.sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options, log_device_placement=False))

            with self.sess.as_default():
                self.pnet, self.rnet, self.onet = detect_face.create_mtcnn(self.sess, None)

            self.minsize = 20 # minimum size of face
            self.threshold = [ 0.6, 0.7, 0.7 ]  # three steps's threshold
            self.factor = 0.709 # scale factor

    def align(self,image, margin=44, image_size=160, training=False):
        img = image[:,:,0:3]
        bounding_boxes, _ = detect_face.detect_face(img, self.minsize, self.pnet, self.rnet, self.onet, self.threshold, self.factor)
        nrof_faces = bounding_boxes.shape[0]
        bb = np.zeros(4, dtype=np.int32)
        if nrof_faces>0:
            det_list = bounding_boxes[:,0:4]
            img_size = np.asarray(img.shape)[0:2]
            if nrof_faces>1 and training:
                bounding_box_size = (det_list[:,2]-det_list[:,0])*(det_list[:,3]-det_list[:,1])
                img_center = img_size / 2
                offsets = np.vstack([ (det_list[:,0]+det_list[:,2])/2-img_center[1], (det_list[:,1]+det_list[:,3])/2-img_center[0] ])
                offset_dist_squared = np.sum(np.power(offsets,2.0),0)
                index = np.argmax(bounding_box_size-offset_dist_squared*2.0) # some extra weight on the centering
                det_list = [det_list[index,:]]
        else:
            return ([bb], None, False)

        bb_list = []
        face_list = []

        for dets in det_list:
            det = np.squeeze(dets)
            bb = np.zeros(4, dtype=np.int32)

            bb[0] = np.maximum(det[0]-margin/2, 0)
            bb[1] = np.maximum(det[1]-margin/2, 0)
            bb[2] = np.minimum(det[2]+margin/2, img_size[1])
            bb[3] = np.minimum(det[3]+margin/2, img_size[0])

            cropped = img[bb[1]:bb[3],bb[0]:bb[2],:]
            scaled = misc.imresize(cropped, (image_size, image_size), interp='bilinear')

            bb_list.append(bb)
            face_list.append(scaled)

        return (bb_list, face_list, True)
