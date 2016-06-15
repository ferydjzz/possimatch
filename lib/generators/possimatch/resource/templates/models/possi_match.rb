class PossiMatch < Possimatch::PossiMatch
  belongs_to :<%= "#{@from_class.tableize.singularize}" %>
  belongs_to :<%= "#{@to_class.tableize.singularize}" %>

  def self.get_possible_matches_data(source_id)
    PossiMatch.all.where("source_id = ?", source_id)
  end
end