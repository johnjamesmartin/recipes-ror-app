require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Mashrur", email: "mashrur@example.com")
    @recipe = Recipe.create(name: "Vegetable saute", description: "Great vegetable saute, add veg and oil", chef: @chef)
  end

  test "successfully delete recipe" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: "Delete this recipe"
    assert_difference 'Recipe.count' -1 do
      delete recipe_path(@recipe)
      assert_redirected_to recipes_path
      assert_not flash.empty?
  end
end
