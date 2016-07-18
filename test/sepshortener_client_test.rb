require 'test_helper'

class TestedClass
  include SepshortenerClient
end

module OtherModule
  include SepshortenerClient
end

class OtherClass
  include OtherModule
end

describe SepshortenerClient do
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

    describe 'when link is freeze and includes only one http prefix' do
      it 'returns link with one http prefix' do
        subject.sanitize_link('http://test_link/123'.freeze).must_equal('http://test_link/123')
      end
    end

    describe 'when link includes only one http prefix' do
      it 'returns link with one http prefix' do
        subject.sanitize_link('http://test_link/123').must_equal('http://test_link/123')
      end
    end

    describe 'when link includes more than one http prefix' do
      it 'returns link with one http prefix' do
        subject.sanitize_link('http://http://http://test_link/123').must_equal('http://test_link/123')
      end
    end
  end

  describe '#real_link' do
    describe 'when link is missing' do
      it 'returns nil' do
        subject.real_link(nil).must_equal nil
      end
    end

    describe 'when link contain INBOUNDSMS token' do
      INBOUNDSMS_HOST = 'site.com'

      it 'replaces token to site' do
        subject.real_link('INBOUNDSMS/index.html').must_equal 'site.com/index.html'
      end
    end

    describe 'when link contain SEPRESEARCH token' do
      SEPRESEARCH_HOST = 'site.com'

      it 'replaces token to site' do
        subject.real_link('SEPRESEARCH/index.html').must_equal 'site.com/index.html'
      end
    end

    describe 'when link contain SEPCONTENT token' do
      SEPCONTENT_HOST = 'site.com'

      it 'replaces token to site' do
        subject.real_link('SEPCONTENT/index.html').must_equal 'site.com/index.html'
      end
    end

  end
end
