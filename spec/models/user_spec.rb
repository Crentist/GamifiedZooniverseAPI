require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:zooniverseHandle).with_message("zooniverseHandle can't be blank") }
  it { should validate_uniqueness_of(:zooniverseHandle).with_message("zooniverseHandle must be unique") }

end
