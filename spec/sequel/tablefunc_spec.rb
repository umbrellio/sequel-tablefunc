require 'spec_helper'
require 'yaml'

RSpec.describe Sequel::Tablefunc do
  before(:all) do
    DB.extension :tablefunc
  end

  let(:categories_ds) do
    DB.select(Sequel.lit("unnest(ARRAY['2017-04-01', '2017-05-01', '2017-06-01'])"))
  end

  let(:result) do
    DB[:data].group(:group, Sequel.cast(:created_at, Date))
             .select(:group, Sequel.as(Sequel.cast(:created_at, Date), :date), Sequel.function(:sum, :value))
             .order(Sequel.lit('1,2'))
             .crosstab(categories_ds)
  end

  it 'works' do
    expect(result.all).to include(
      a_hash_including(
        :category => 'a', :"2017-04-01" => '1', :"2017-05-01" => '3', :"2017-06-01" => nil
      ),
      a_hash_including(
        :category => 'b', :"2017-04-01" => '1', :"2017-05-01" => '1', :"2017-06-01" => nil
      )
    )
  end

  it 'has a version number' do
    expect(Sequel::Tablefunc::VERSION).not_to be nil
  end
end
