# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: tensors.proto

require 'google/protobuf'

require 'treyja/proto/tensor_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "tensors.TensorsProto" do
    repeated :tensors, :message, 1, "tensor.TensorProto"
  end
end

module Tensors
  TensorsProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("tensors.TensorsProto").msgclass
end
