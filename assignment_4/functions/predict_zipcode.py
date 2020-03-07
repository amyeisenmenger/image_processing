import torch
from torch.autograd import Variable
from torchvision import transforms
from .net import Net
from .extract_connected_components import *

import os
output = os.path.join(os.path.dirname(__file__), '..', 'output')

input = os.path.join(os.path.dirname(__file__), '..', 'input/zip_codes/')

def predict_zipcode(filename, model=None):

	# EXTRACT DIGITS FROM IMAGE AND LOCAITON
	digits, digit_lefts = extract_component(filename)

	# LOAD MODEL
	if model is None:
		model = Net()
		model.load_state_dict(torch.load(output + '/model.pth'))

	model.eval()

	zipcode = []
	for digit in digits:
		# TRANSFORM TO TENSOR AND VARIABLE
		test_transforms = transforms.Compose([
											transforms.ToTensor()
										])
		digit_tensor = test_transforms(digit).float()
		digit_tensor.unsqueeze_(0)
		im_in = Variable(digit_tensor)

		# PREDICT
		result = model(im_in)
		_, predicted = torch.max(result, 1)
		zipcode.append(predicted.item())

	# SORT BY ORIGINAL LOCATION
	final = ([x for _,x in sorted(zip(digit_lefts,zipcode))])
	return final
	