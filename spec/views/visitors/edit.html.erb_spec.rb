require 'rails_helper'

RSpec.describe "visitors/edit", type: :view do
  before(:each) do
    @visitor = assign(:visitor, Visitor.create!(
      :ticked_id => "MyString",
      :event_type => "MyString",
      :timestamp => "MyString",
      :total_visitors => 1
    ))
  end

  it "renders the edit visitor form" do
    render

    assert_select "form[action=?][method=?]", visitor_path(@visitor), "post" do

      assert_select "input#visitor_ticked_id[name=?]", "visitor[ticked_id]"

      assert_select "input#visitor_event_type[name=?]", "visitor[event_type]"

      assert_select "input#visitor_timestamp[name=?]", "visitor[timestamp]"

      assert_select "input#visitor_total_visitors[name=?]", "visitor[total_visitors]"
    end
  end
end
