class PosterController < ApplicationController

    def index
      @every_post=Poster.all.order("id desc")
    end
    def create
      
    end
  
    def upload
    
      @user_id=Poster.new
      @user_id.intro=params[:intro]
      @user_id.host=params[:host]
      @user_id.place=params[:place]
      @user_id.user_id=1
      @user_id.category=params[:category]
      @user_id.image= params[:image].original_filename
      File.open(Rails.root.join('app','models','poster', @user_id), 'wb') do |file|
      File.write(@user_id.data)
      
      @user_id.save
      
      redirect_to '/poster/index'
      end
    end
    
    def detail
       
        @poster = Poster.find(params[:id])
      
        if(@poster.category == 0)
                @category = "대외활동"
        elsif(@poster.category == 1)
                @category = "동아리"
        elsif(@poster.category == 2)
                 @category = "학과 행사"
        elsif(@poster.category ==3)
                 @category = "교내 행사"
        elsif(@poster.category == 4)
                 @category = "장학금"
        elsif(@poster.category == 5)
                 @category = "교외행사"
        elsif(@poster.category == 6)
                 @category = "기타"
        else
            @category = "error"
        end
        puts "like?"
        
        @like = LikePost.where("poster_id = ?", params[:id]).length
        
        @like_user = like_check(current_user.id,params[:id])
        
         
    end
    
    def like 
     
        like = LikePost.find_by(user_id: current_user.id ,
                                poster_id: params[:post_id])
        puts like
        if(like.nil?)
            #create
            puts "like"
            col = LikePost.new
            col.user_id = current_user.id 
            col.poster_id = params[:post_id]
            col.save
        else
            puts "delete"
            like.destroy
        end
        @count =  LikePost.where("poster_id = ?", params[:id]).length
        puts @count
        if request.xhr?
            render :json => {
                                :count => @count,
                            }
        end
    end
    
    #좋아요 체크 기능 
    def like_check(user,post)
         like_user = ""
         puts "조아요눌럿나여?"
         puts LikePost.find_by(user_id: user ,poster_id: post)
         if LikePost.find_by(user_id: user ,poster_id: post)
             puts 'if'
             like_user = "heart heart_off" # 눌럿을때 하트가 밝아야댐
         else
             puts 'else'
             like_user = "heart"
         end
         return like_user
    end
end
# 멋쟁이 사자처럼 0 
# 동아리 1
# 학과 행사 2
# 교내 행사 3
# 장학금 4
# 교외 행사 5
# 기타 6
#회원가입 시 email로 받는다. 