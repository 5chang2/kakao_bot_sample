class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
      :type => "buttons",						# 이렇게 작성해도
      buttons: ["로또", "메뉴", "고양이"]		 # 요렇게 작성해도 똑같습니다.
    }
    render json: @keyboard
  end

  def message
    @user_msg = params[:content] # 사용자가 보낸 내용은 content에 담아서 전송됩니다.
    
    # 여기에
    # 코드를
    # 적어주세요.
    if @user_msg == "로또"
      #@msg = "로또를 선택했습니다."
      @msg = (1..46).to_a.sample(6).to_s
    elsif @user_msg == "메뉴"
      @msg = ["20층","시골밥","중국집","편의점","다이어트"].sample
    elsif @user_msg == "고양이"
      @msg = "고양이를 선택했습니다."
      @cat_xml = RestClient.get 'http://thecatapi.com/api/images/get?format=xml&type=jpg'
      @doc = Nokogiri::XML(@cat_xml)
      @cat_url = @doc.xpath("//url").text
    else
      @msg = "잘못선택했습니다."
    end
    
    # 메세지를 넣어봅시다.
    @message = {
      text: @msg
    }
    @message_photo ={
      text: "나만고양이없어",
      photo: {
        url: @cat_url,
        width: 640,
        height: 480
      }
    }
    
    # 자주 사용할 키보드를 만들어 주겠습니다.
    @basic_keyboard = {
      :type => "buttons",						
      buttons: ["로또", "메뉴", "고양이"]
    }
    
    # 응답
    if @user_msg == "고양이"
      @result = {
        message: @message_photo,
        keyboard: @basic_keyboard
      }
    else
      @result = {
        message: @message,
        keyboard: @basic_keyboard
      }
    end
    
    render json: @result
  end
end

