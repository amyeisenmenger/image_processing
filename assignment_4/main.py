from functions.classify_digits import *
from functions.classify_even_odd import *
from functions.predict_zipcode import *
import os

# CLASSIFY NUMERIC DIGITS
print("Building CNN")
model = classify_digits()
print("Model Complete\n")

# CLASSIFY EVEN-ODD VARIATION
print("Transfer Learning Even/Odd Labels")
# # classify_even_odd(model)
classify_even_odd()
print("Transfer Learning Complete\n")

# PREDICT ZIPCODES
print("Predicting Zipcodes")
path  = os.path.join(os.path.dirname(__file__), '.', 'input/zip_codes/')
files = os.listdir(path)
correct = 0
total = 0
for name in files:
	if name[0] != '.':
		label = (name.split('.')[0])
		label = [int(x) for x in label]
		total += 5
		prediction = predict_zipcode(name)
		l = len(prediction)
		for i in range(l):
			if i < 5 and label[i] == prediction[i]:
				correct += 1
		print(name + " contains " + ''.join(str(prediction)))

print("\nZipcode Digit Accuracy:")
print(correct/total)