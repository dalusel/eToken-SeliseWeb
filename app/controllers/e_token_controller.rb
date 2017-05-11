class ETokenController < ApplicationController
  before_action :set_etoken, only: [:show, :edit, :update]

  def index
      @etokendetail = ETokenDetail.all
  end

  def search
  end

  def new
      gon.isButtonClick = false
      @institution = Institution.all
      @institutiontype = InstitutionType.all
      @place =Place.all
      @equotum = EQuotum.all
      @etokendetail = ETokenDetail.new
      defaultValue     
  end

  def show
  end

  def edit
  end

  def destroy
      @taskstatus = ETokenDetail.find(params[:id])
      adjustTokenNoAfterCancel
      @taskstatus.destroy
      defaultValue
      redirect_to(:action=>'new')
  end

  def delete
  end

  def update
  end


  def create      
      gon.isButtonClick = true       
      if params[:SearchToken]
           @etokendetail = ETokenDetail.new(etoken_params)
           defaultValue           
           searchToken
           respond_to do |format|
               format.html { render :new }
               format.json { render json: @etokendetail.errors, status: :unprocessable_entity }
           end
      elsif params[:CancelToken]
          destroy
      else
          @etokendetail = ETokenDetail.new(etoken_params)
          @etokendetail.errors.delete(:all)
          assignToken
          defaultValue
          respond_to do |format|
            if @etokendetail.errors.size == 0
                if @etokendetail.save
                   gon.errorCount = 0
                   gon.ETokenID = @etokendetail.id
                   defaultValue  
                      format.html { render :new}
                      format.json { render json: @etokendetail.errors, status: :unprocessable_entity }
                else
                    gon.errorCount = @etokendetail.errors.size  
                    gon.ETokenID = @etokendetail.id                    
                    format.html { render :new }
                    format.json { render json: @etokendetail.errors, status: :unprocessable_entity }
                end
            else
                gon.errorCount = @etokendetail.errors.size
                gon.ETokenID = @etokendetail.id
                format.html { render :new }
                format.json { render json: @etokendetail.errors, status: :unprocessable_entity }
            end
          end
      end
  end

  private
  def etoken_params   
      params.require(:e_token_detail).permit(:Institutions_id,:InstitutionType_id,:Places_id,:PhoneNo,:Name,:RequestDate)
  end

  private
  def etoken_params_forupdate
      params.permit(:task,:status,:remainder)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_etoken    
      @etokendetail = ETokenDetail.find(params[:id])
  end

  def defaultValue
    if params[:CancelToken]
      @etokendetail= ETokenDetail.new
    end
    gon.Institution=@etokendetail.Institutions_id
    gon.InstitutionType = @etokendetail.InstitutionType_id
    gon.Place=@etokendetail.Places_id
    gon.PhoneNo =@etokendetail.PhoneNo
    gon.Name =@etokendetail.Name
    gon.ETokenID =@etokendetail.id
  end

  def searchToken
    tomorrowDate = Date.today() + 1
    @equotum = EQuotum.where("Places_id = ?",gon.Place).take 1
    if @equotum.size > 0
      gon.totalToken = @equotum[0].TotalToken
      @totalToken = gon.totalToken
      @usedToken = ETokenDetail.where("Places_id =? and  RequestDate like ?",gon.Place,tomorrowDate).size
      gon.usedToken = @usedToken
      gon.availableToken = gon.totalToken - gon.usedToken
      @availableToken = gon.availableToken
    else
      gon.totalToken=0
      gon.usedToken=0
      gon.availableToken=0
    end
  end

  def assignToken  #find last token no of that place for next day and assign the next TokenNo if available
     tomorrowDate = Date.today() + 1
     @equotum = EQuotum.where("Places_id  = ?",@etokendetail.Places_id).take 1
     @allTokens = ETokenDetail.where("Places_id  = ? and RequestDate like ?",@etokendetail.Places_id,tomorrowDate)
     @allTokens = @allTokens.sort_by {|k| k[:TokenNo] }.reverse

     if(@equotum.size > 0)
        gon.totalToken = @equotum[0].TotalToken
        if(@allTokens.size > 0)
            gon.usedToken =@allTokens.size
            if(@allTokens[0].TokenNo < @equotum[0].TotalToken)
                 lastTokenNo = @allTokens[0].TokenNo
                 if(lastTokenNo == nil)
                        lastTokenNo =0
                 end
                 gon.usedToken =  gon.usedToken + 1
                 @etokendetail.TokenNo =lastTokenNo + 1
                 gon.yourTokenNo =   @etokendetail.TokenNo
                 @etokendetail.RequestDate = tomorrowDate
            else
                  @etokendetail.errors.add(:TokenNo, "All the tokens are over")
            end
        else
            gon.usedToken =1
            gon.yourTokenNo =1
            @etokendetail.TokenNo =1
            @etokendetail.RequestDate = tomorrowDate
        end
        gon.availableToken = gon.totalToken - gon.usedToken
        assignTimming
     end
  end

  def assignTimming
    if gon.yourTokenNo != nil
      totalMinutes = gon.yourTokenNo * 10
      tokenHour = totalMinutes/60
      tokenMinute = totalMinutes % 60
      actualTokenHour = 9 + tokenHour
      if(actualTokenHour >= 12)
        if(actualTokenHour != 12 )
          actualTokenHour = actualTokenHour - 12
        end
        dayType = "PM"
      else
        dayType = "AM"
      end
      gon.tokenTime = actualTokenHour.to_s+":"+tokenMinute.to_s+" "+dayType
    end
  end

  def adjustTokenNoAfterCancel
    tomorrowDate = Date.today() + 1
    @tokenCancel = ETokenDetail.find(params[:id])
    deletingTokenNo =  @tokenCancel.TokenNo
    @tokenToAdjust = ETokenDetail.where(Places_id: @tokenCancel.Places_id,RequestDate:tomorrowDate)
    @tokenToAdjust.each do |item|
    if item.TokenNo > @tokenCancel.TokenNo
      curTokenNo = item.TokenNo.to_f - 1
      item.update_attributes(TokenNo: curTokenNo)
    end
    end
  end
end
