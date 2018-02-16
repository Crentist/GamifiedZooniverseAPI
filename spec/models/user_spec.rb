require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:handle).with_message("handle can't be blank") }
  it { should validate_uniqueness_of(:handle).with_message("handle must be unique") }

end
