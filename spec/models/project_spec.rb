require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should validate_presence_of(:name).with_message("Project name can't be blank") }
end
