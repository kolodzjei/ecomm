require 'rails_helper'

RSpec.describe Authentication do
  let(:dummy_class) { Class.new(ApplicationController) { include Authentication } }

  it 'is included in ApplicationController' do
    expect(ApplicationController.ancestors).to include Authentication
  end
end