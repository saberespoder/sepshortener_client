require 'test_helper'

class TestedClass
  include ShortenUrlClient
end

module OtherModule
  include ShortenUrlClient
end

class OtherClass
  include OtherModule
end

describe ShortenUrlClient do
  let(:subject) { TestedClass.new }

  it 'works' do
    subject.short_url(nil).must_equal nil
  end

  it 'works in other module' do
    OtherClass.new.short_url(nil).must_equal nil
  end

  describe '#short_url' do
  end

  describe '#sanitize_link' do
    describe 'with ssl' do
      before do
        ::Rails.stub_method_chain('application.config.force_ssl') { true }
      end

      describe 'when link do not includes https prefix' do
        it 'returns link with one https prefix' do
          subject.sanitize_link('test_link/123').must_equal('https://test_link/123')
        end
      end

      describe 'when link includes only one http prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('http://test_link/123').must_equal('https://test_link/123')
        end
      end

      describe 'when link includes only one https prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('https://test_link/123').must_equal('https://test_link/123')
        end
      end

      describe 'when link includes more than one http prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('https://https://https://test_link/123').must_equal('https://test_link/123')
        end
      end
    end

    describe 'without ssl' do
      before do
        ::Rails.stub_method_chain('application.config.force_ssl') { false }
      end

      describe 'when link do not includes http prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('test_link/123').must_equal('http://test_link/123')
        end
      end

      describe 'when link includes only one http prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('http://test_link/123').must_equal('http://test_link/123')
        end
      end

      describe 'when link includes only one http prefix' do
        it 'returns link with one https prefix' do
          subject.sanitize_link('https://test_link/123').must_equal('http://test_link/123')
        end
      end

      describe 'when link includes more than one http prefix' do
        it 'returns link with one http prefix' do
          subject.sanitize_link('http://http://http://test_link/123').must_equal('http://test_link/123')
        end
      end
    end
  end

  describe '#real_link' do
  end
end
