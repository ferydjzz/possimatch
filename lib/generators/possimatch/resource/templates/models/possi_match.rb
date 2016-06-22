class PossiMatch < Possimatch::PossiMatch
  belongs_to :from_source, class_name: '<%= @from_class.classify %>'
  belongs_to :to_source, class_name: '<%= @to_class.classify %>'
  belongs_to :source, class_name: '<%= @group_key.split("_id").first.classify %>' 
end