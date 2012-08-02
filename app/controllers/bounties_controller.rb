class BountiesController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]

  # GET /bounties
  # GET /bounties.json
  def index
    params[:sort] = params[:sort] || 'DESC'
    if params[:sort] == 'DESC'
      @sortname = "By Newest"
    else
      @sortname = "By Oldest"
    end
    @sort = params[:sort]

    claimed = params[:claimed] == 'true' ? true : false

    if params[:claimed].nil? or params[:claimed] == 'all'
      @bounties = Bounty.find(:all, :order => 'updated_at ' + params[:sort])
      @claimed = 'all'
      @claimedname = 'Show All'
    else
      @bounties = Bounty.where(:claimed => claimed).order('updated_at ' + params[:sort])
      @claimed = claimed
      if (claimed)
        @claimedname = "Show Claimed"
      else
        @claimedname = "Show Unclaimed"
      end
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bounties }
    end
  end

  # GET /bounties/1
  # GET /bounties/1.json
  def show
    @bounty = Bounty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bounty }
    end
  end

  # GET /bounties/new
  # GET /bounties/new.json
  def new
    @bounty = Bounty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bounty }
    end
  end

  # GET /bounties/1/edit
  def edit
    @bounty = Bounty.find(params[:id])
  end

  # POST /bounties
  # POST /bounties.json
  def create
    @bounty = Bounty.new(params[:bounty])
    @bounty.user_bounties.build(:user => current_user, :owner => true)

    respond_to do |format|
      if @bounty.save
        format.html { redirect_to @bounty }
        format.json { render json: @bounty, status: :created, location: @bounty }
      else
        format.html { render action: "new" }
        format.json { render json: @bounty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bounties/1
  # PUT /bounties/1.json
  def update
    @bounty = Bounty.find(params[:id])
    @bounty.user_bounties.build(:user => current_user, :owner => false)

    respond_to do |format|
      if @bounty.update_attributes(params[:bounty])
        format.html { redirect_to @bounty, notice: 'Bounty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bounty.errors, status: :unprocessable_entity }
      end
    end
  end

  def addBounty
    @bounty = Bounty.find(params[:id])
    @bounty.user_bounties.build(:user => current_user, :owner => false)

    if @bounty.save
      redirect_to @bounty, notice: 'Bounty successfully claimed'
    else
      redirect_to @bounty, notice: "something got messed up"
    end
  end

   def removeBounty
    @bounty = Bounty.find(params[:id])
    @bounty.user_bounties.find_by_user_id( current_user.id ).destroy

    if @bounty.save
      redirect_to @bounty, notice: 'Bounty successfully unclaimed'
    else
      redirect_to @bounty, notice: "something got messed up"
    end
  end

  # DELETE /bounties/1
  # DELETE /bounties/1.json
  def destroy
    @bounty = Bounty.find(params[:id])
    @bounty.destroy

    respond_to do |format|
      format.html { redirect_to bounties_url }
      format.json { head :no_content }
    end
  end
end
