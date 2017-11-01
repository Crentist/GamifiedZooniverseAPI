require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should validate_presence_of(:name).with_message("Badge name can't be blank") }
  it { should validate_presence_of(:description).with_message("Badge description can't be blank") }
  it { should validate_presence_of(:criteria).with_message("Badge criteria can't be blank") }
end
