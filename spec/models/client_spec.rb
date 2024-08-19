# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client do
  it "has a valid factory" do
    expect(create(:client)).to be_valid
  end
end
