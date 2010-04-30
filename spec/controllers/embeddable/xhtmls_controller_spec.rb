require 'spec_helper'

describe Embeddable::XhtmlsController do

  it_should_behave_like 'an embeddable controller'

  def with_tags_like_an_otml_xhtml
    with_tag('OTCompoundDoc') do
      with_tag('bodyText')
    end
  end

end
