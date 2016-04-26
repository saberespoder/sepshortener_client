require 'test_helper'


class TestedClass
  include ShortenUrlClient
end

describe ShortenUrlClient do
  let(:subject) { TestedClass.new }

  it 'work' do
    subject.short_url.must_equal nil
  end
end
