# FAILING SPEC

# require 'spec_helper'

# describe "bookmarks/index" do
#   before(:each) do
#     assign(:bookmarks, [
#       stub_model(Bookmark,
#         :bookmarks_category_id => 1,
#         :item_id => 2,
#         :bookmark_url => "Bookmark Url",
#         :title => "Title",
#         :i_frame => "I Frame",
#         :image_name => "Image Name",
#         :image_name_desc => "Image Name Desc",
#         :description => "MyText"
#       ),
#       stub_model(Bookmark,
#         :bookmarks_category_id => 1,
#         :item_id => 2,
#         :bookmark_url => "Bookmark Url",
#         :title => "Title",
#         :i_frame => "I Frame",
#         :image_name => "Image Name",
#         :image_name_desc => "Image Name Desc",
#         :description => "MyText"
#       )
#     ])
#   end

#   it "renders a list of bookmarks" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => 1.to_s, :count => 2
#     assert_select "tr>td", :text => 2.to_s, :count => 2
#     assert_select "tr>td", :text => "Bookmark Url".to_s, :count => 2
#     assert_select "tr>td", :text => "Title".to_s, :count => 2
#     assert_select "tr>td", :text => "I Frame".to_s, :count => 2
#     assert_select "tr>td", :text => "Image Name".to_s, :count => 2
#     assert_select "tr>td", :text => "Image Name Desc".to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#   end
# end
