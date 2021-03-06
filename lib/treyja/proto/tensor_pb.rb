# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: tensor.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "tensor.TensorProto" do
    repeated :dims, :int64, 1
    optional :data_type, :enum, 2, "tensor.TensorProto.DataType"
    repeated :int32_data, :int32, 3
    repeated :int64_data, :int64, 4
    repeated :uint32_data, :uint32, 5
    repeated :uint64_data, :uint64, 6
    repeated :float_data, :float, 7
    repeated :double_data, :double, 8
    optional :byte_data, :bytes, 9
  end
  add_enum "tensor.TensorProto.DataType" do
    value :INT8, 0
    value :INT16, 1
    value :INT32, 2
    value :INT64, 3
    value :UINT8, 4
    value :UINT16, 5
    value :UINT32, 6
    value :UINT64, 7
    value :FLOAT, 8
    value :DOUBLE, 9
  end
end

module Tensor
  TensorProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("tensor.TensorProto").msgclass
  TensorProto::DataType = Google::Protobuf::DescriptorPool.generated_pool.lookup("tensor.TensorProto.DataType").enummodule
end
