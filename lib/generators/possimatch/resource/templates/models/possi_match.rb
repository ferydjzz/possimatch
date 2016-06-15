class PossiMatch < Possimatch::PossiMatch
  belongs_to :<%= "#{@from_class.tableize.singularize}" %>
  belongs_to :<%= "#{@to_class.tableize.singularize}" %>

  def get_possible_matches_data(source_id)
    PossiMatch.all.where("source_id = ?", source_id)
  end
end