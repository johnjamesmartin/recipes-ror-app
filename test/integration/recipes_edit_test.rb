require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Mashrur", email: "mashrur@example.com")
    @recipe = Recipe.create(name: "Vegetable saute", description: "Great vegetable saute, add veg and oil", chef: @chef)
  end

  test "reject invalid recipe update"
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "some description" }}
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "successfully edit recipe"
  end

end
