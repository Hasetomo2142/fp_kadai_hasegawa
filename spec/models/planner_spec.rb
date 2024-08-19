# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Planner do
  it "has a valid factory" do
    expect(create(:planner)).to be_valid
  end
end
