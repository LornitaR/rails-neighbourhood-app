namespace :import do

  desc "import neighbourhoods from CSV"
  task neighbourhood: :environment do
    require 'csv'
    CSV.foreach('tmp/neighbourhoods.csv', headers: true) do |row|
        neighbourhood = Neighbourhood.find_or_create_by(name: row['name'])
        # to_h adds to hash
        # column name is key, attribute is the value
        # eg num_businesses: 2
        neighbourhood.update_attributes(row.to_h)
        printf("\r %s", [':)', ':O', ':P', ':D', ':/'].sample)
    end
  end

end