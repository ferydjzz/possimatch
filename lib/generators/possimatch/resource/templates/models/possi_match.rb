class PossiMatch < Possimatch::PossiMatch
  belongs_to :from_source, class_name: '<%= @from_class.tableize.singularize %>'
  belongs_to :to_source, class_name: '<%= @to_class.tableize.singularize %>'
  belongs_to :source, class_name: '<%= @group_key.split("_id").first.classify %>' 

  def self.get_possible_matches_data(source_id)
    PossiMatch.all.where("source_id = ?", source_id)
  end
end