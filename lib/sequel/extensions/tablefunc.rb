require "sequel/extensions/tablefunc/version"
require 'sequel/model'

module Sequel
  module Tablefunc
    def crosstab(categories_dataset)
      data_sql = tablefunc_quote(self.sql)
      categories_sql = tablefunc_quote(categories_dataset.sql)
      categories_types = DB[categories_dataset].all.map(&:values).flatten.map{|i| "\"#{i}\" text"}.join(', ')
      DB.from(Sequel.lit("crosstab('#{data_sql}','#{categories_sql}') as ct(row_name text, #{categories_types})"))
    end

    private

    def tablefunc_quote(query)
      return query.gsub("'","''")
    end

    Dataset.register_extension(:tablefunc, Tablefunc)
  end
end
