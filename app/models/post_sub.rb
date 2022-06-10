class PostSub < ApplicationRecord
  belongs_to :sub
  belongs_to :post
end
