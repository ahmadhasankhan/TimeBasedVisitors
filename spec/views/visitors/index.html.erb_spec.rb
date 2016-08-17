require 'rails_helper'

RSpec.describe "visitors/index", type: :view do
  before(:each) do
    assign(:visitors, [
      Visitor.create!(
        :ticked_id => "Ticked",
        :event_type => "Event Type",
        :timestamp => "Timestamp",
        :total_visitors => 2
      ),
      Visitor.create!(
        :ticked_id => "Ticked",
        :event_type => "Event Type",
        :timestamp => "Timestamp",
        :total_visitors => 2
      )
    ])
  end

  it "renders a list of visitors" do
    render
    assert_select "tr>td", :text => "Ticked".to_s, :count => 2
    assert_select "tr>td", :text => "Event Type".to_s, :count => 2
    assert_select "tr>td", :text => "Timestamp".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
