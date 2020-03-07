
import matplotlib.pyplot as plt
import os, sys
output = os.path.join(os.path.dirname(__file__), '..', 'output')

def visualize_weights(layer):
	fig = plt.figure()
	fig.suptitle("First Convolutional Layer Weights")
	fig.subplots_adjust(hspace=.5)
	for i, filter in enumerate(layer):
		subplt = fig.add_subplot(4, 5, i + 1)
		subplt.imshow(filter.numpy().squeeze(), cmap="gray")
		txt="Filter " + str(i + 1)
		subplt.set_title(txt)
		subplt.axis('off')
	fig.savefig(output +'/conv1_weights.png')