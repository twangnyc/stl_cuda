require 'cunn'
require 'nn'
require 'cutorch'
require 'image'
require 'xlua'
require 'unsup'
matio = require 'matio'

torch.setdefaulttensortype('torch.CudaTensor')
print("==> load dataset")
traindata = matio.load('/scratch/courses/DSGA1008/A2/matlab/train.mat')
traindata.X = torch.reshape(traindata.X, 5000,3,96,96):float()
traindata.X = traindata.X:transpose(3,4)
testdata = matio.load('/scratch/courses/DSGA1008/A2/matlab/test.mat')
testdata.X = torch.reshape(testdata.X, 8000,3,96,96):float()
testdata.X = testdata.X:transpose(3,4)
--data_fd = torch.DiskFile("/scratch/courses/DSGA1008/A2/binary/unlabeled_X.bin", "r", true)
--data_fd:binary():littleEndianEncoding()
--unlabeledtotalsize = 100000
--unlabeled = torch.ByteTensor(unlabeledtotalsize, 3, 96, 96)
--data_fd:readByte(unlabeled:storage())
--unlabeled= unlabeled:float()
--data_fd = nil

-- set parameters
patchSize = 7
ncenter = 64
trsize = 5000
testsize = 8000
--unlabelsize = 100000

-- Normalization

print("==> Normalization")
for i = 1,trsize do
        xlua.progress(i, trsize)
        traindata.X[i] = traindata.X[i]:div(torch.max(torch.abs(traindata.X[i])))
        traindata.X[i] = traindata.X[i]:add(torch.mean(traindata.X[i]))
	collectgarbage()
end

print("==> for test")
for i = 1,testsize do
        xlua.progress(i, testsize)
        testdata.X[i] = testdata.X[i]:div(torch.max(torch.abs(testdata.X[i])))
        testdata.X[i] = testdata.X[i]:add(torch.mean(testdata.X[i]))
	collectgarbage()
end
collectgarbage()