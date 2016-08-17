require 'rails_helper'

RSpec.describe "visitors/show", type: :view do
  before(:each) do
    @visitor = assign(:visitor, Visitor.create!(
      :ticked_id => "Ticked",
      :event_type => "Event Type",
      :timestamp => "Timestamp",
      :total_visitors => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Ticked/)
    expect(rendered).to match(/Event Type/)
    expect(rendered).to match(/Timestamp/)
    expect(rendered).to match(/2/)
  end
end
