crumb :root do
  link "ホーム", root_path
end

crumb :mypage do
  link "マイページ", user_path(current_user)
end

crumb :user_edit do
  link "プロフィール編集", edit_users_path
  parent :mypage
end

crumb :password_edit do
  link "パスワード編集", password_edit_users_path
  parent :user_edit
end

crumb :favorite_recipes do
  link "お気に入りレシピ", favorite_recipes_users_path
end

crumb :friends do
  link "友だち", friends_users_path
  parent :mypage
end

crumb :user do |user|
  link "#{user.name}", user_path(user)
  parent :friends
end

crumb :recipe do |recipe|
  link "#{recipe.title}", recipe_path(recipe)
end

crumb :recipe_new do
 link "レシピ概要の入力", new_recipes_path
end

crumb :recipe_edit do |recipe|
  link "レシピ概要の入力", edit_recipe_path(recipe)
  parent :recipe, recipe
end

crumb :ingredients_edit do |recipe|
  link "材料の入力", edit_recipe_ingredients_path(recipe)
  parent :recipe_edit, recipe
end

crumb :steps_edit do |recipe|
  link "手順の入力", edit_recipe_steps_path(recipe)
  parent :ingredients_edit, recipe
end


# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).