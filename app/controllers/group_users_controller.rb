class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    #current_userを使用して、現在のユーザーを取得し、group_usersに.newメソッドで新しいレコードを作成。
    #その際、group_idを渡して、どのグループに参加するかを指定
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
    #前にいたページに戻る
    redirect_to request.referer
  end

  def destroy
    #ログインしているユーザーの group_users 関連付けを使用して、指定されたグループに関連付けられた group_userインスタンスをfind_byメソッドで検索
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    #前にいたページに戻る
    redirect_to request.referer
  end

end