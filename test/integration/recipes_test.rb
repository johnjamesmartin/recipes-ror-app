require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Mashrur", email: "mashrur@example.com")
    @recipe = Recipe.create(name: "Vegetable saute", description: "Great vegetable saute, add veg and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "Chicken saute", description: "Great chicken dish")
    @recipe2.save
  end


  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get recipes show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe), text: "Edit this recipe"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete this recipe"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Return to recipes listing"
  end


end
