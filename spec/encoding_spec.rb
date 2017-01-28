require 'spec_helper'
require_relative '../huffman_encoder'

RSpec.describe 'Huffman encoding' do
  describe 'the first example string' do
    let(:input) { 'ABRRKBAARAA' }

    let(:encoding_table) do
      HuffmanEncoder.make_encoding_table(input)
    end

    describe 'the encoding table' do
      it 'does not have encodings that prefix of other encodings' do
        encodings = encoding_table.values.sort_by(&:length)
        expect(encodings.length).to be_positive
        prefixed_encodings = []

        until encodings.empty?
          cur = encodings.shift
          encodings.each do |test|
            if test.slice(0..cur.length - 1) == cur
              prefixed_encodings.push([cur, test])
            end
          end
        end

        expect(prefixed_encodings).to be_empty
      end
    end

    describe 'encoding the input string' do
      subject(:encoded) { HuffmanEncoder.encode(input) }

      it 'is expected to a be a string of 0s and 1s' do
        is_expected.to match(/\A[0-1]+\z/)
      end
    end

    describe 'decoding an input string with a known tree' do
      let(:tree) { HuffmanEncoder.build_tree_from_string(input) }
      let(:encoded) { tree.encode(input) }

      subject { tree.decode(encoded) }

      it 'decodes back to the original input' do
        is_expected.to eq input
      end
    end
  end
end
