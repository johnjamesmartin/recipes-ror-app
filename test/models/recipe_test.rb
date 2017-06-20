require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
    def setup
        @chef = Chef.create!(chefname: "mashrur", email: "mashrur@example.com")
        @recipe = @chef.recipes.build(name: "Vegetable", description: "great vegetable recipe")
    end

    test "recipe should be valid" do
        assert @recipe.valid?
    end

    test "recipe without chef should be invalid" do
        @recipe.chef_id = nil
        assert_not @recipe.valid?
    end

    test "name should be present" do
        @recipe.name = " "
        assert_not @recipe.valid?
    end

    test "description should be present" do
        @recipe.description = " "
        assert_not @recipe.valid?
    end

    test "description should not be less than 5 characters" do
        @recipe.description = "a" * 3
        assert_not @recipe.valid?
    end

    test "description should not exceed 500 characters" do
        @recipe.description = "a" * 501
        assert_not @recipe.valid?
    end

    test "create new valid recipe" do
        get new_recipe_path
        assert_template 'recipes/new'
        name_of_recipe = "chicken saute"
        description_of_recipe = "add chicken, add vegetables, cook for 20 minutes, serve delicious meal"
        assert_difference 'Recipe.count', 1 do
            post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
        end
        follow_redirect!
        assert_match name_of_recipe.capitalize, response.body
        assert_match description_of_recipe, response.body
    end

    test "reject invalid recipe" do
        get new_recipe_path
        assert_template 'recipes/new'
        assert_no_difference 'Recipe.count' do
            post recipes_path, params: { recipe: { name: " ", description: " " } }
        end
        assert_template 'recipes/new'
        assert_select 'h2.panel-title'
        assert_select 'div.panel-body'
    end

    test "successfully edit a recipe" do
        get edit_recipe_path(@recipe)
        assert_template 'recipes/edit'
        updated_name = "updated recipe name"
        updated_description = "updated recipe description"
        patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description }})
        assert_redirected_to
        assert_not flash.empty?
        @recipe.reload
        assert_match updated_name, @recipe.name
        assert_match updated_description, @recipe.description
    end
end