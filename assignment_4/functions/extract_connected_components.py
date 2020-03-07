import matplotlib.pyplot as plt
from scipy import ndimage
import cv2
import numpy as np
import math

import os
input = os.path.join(os.path.dirname(__file__), '..', 'input/zip_codes/')

# Modified from
# https://medium.com/@o.kroeger/tensorflow-mnist-and-your-own-handwritten-digits-4d1cd32bbab4

def extract_component(filename):
	img = cv2.imread(input + filename, 0)
	# BLUR NOISE
	img = cv2.GaussianBlur(255-img, (5, 5), 0)

	# THRESHOLD TO REMOVE NOISE
	(thresh, img) = cv2.threshold(img, 128, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)

	# FIND CONNECTED COMPONENTS AND LOCATION
	stats = cv2.connectedComponentsWithStats(img,connectivity=8)
	num_labels = stats[0]
	labels = stats[1]
	label_stats = stats[2]

	digits = []
	digit_lefts = []

	for label in range(num_labels):
		# SKIP BACKGROUND
		if label == 0:
			continue

		# CROP BY BOUNDS
		left = label_stats[label,cv2.CC_STAT_LEFT]
		top = label_stats[label, cv2.CC_STAT_TOP]
		width = label_stats[label, cv2.CC_STAT_WIDTH]
		height = label_stats[label, cv2.CC_STAT_HEIGHT]
		digit = labels[top:top+height,left:left+width]

		# TRACK ORDER IN ORGINIAL IMAGE
		digit_lefts.append(left)

		# RESIZE TO 20X20 BOX
		num_rows,num_cols = digit.shape
		new_size = 20.0
		r =  float(new_size)/max(num_rows,num_cols)
		new_height = int(round(num_rows*r))
		new_width = int(round(num_cols*r))
		dim = (new_width,new_height)
		# new_size should be in (width, height) format
		resized = cv2.resize(digit.astype('float32'), dim)

		# PAD TO 28X28 BOX
		colsPadding = (int(math.ceil((28-new_width)/2.0)),int(math.floor((28-new_width)/2.0)))
		rowsPadding = (int(math.ceil((28-new_height)/2.0)),int(math.floor((28-new_height)/2.0)))
		resized = np.lib.pad(resized,(rowsPadding,colsPadding),'constant')

		# GET CENTER OF MASS AND TRANSFORM
		cy,cx = ndimage.measurements.center_of_mass(resized)
		rows,cols = resized.shape
		shiftx = np.round(cols/2.0-cx).astype(int)
		shifty = np.round(rows/2.0-cy).astype(int)
		M = np.float32([[1,0,shiftx],[0,1,shifty]])
		resized = cv2.warpAffine(resized,M,(cols,rows))

		digits.append(resized)


	return digits, digit_lefts







