class Reply < ActiveRecord::Base
    belongs_to :user
    belongs_to :poster
end
