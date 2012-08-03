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

    if params[:status].nil?
      status = 'all'
    else
      status = params[:status]
    end

    if params[:status].nil? or params[:status] == 'all'
      if params[:search].nil?
        @bounties = Bounty.find(:all, :order => 'updated_at ' + params[:sort])
      else
        @bounties = Bounty.find(:all, :conditions => ["problem LIKE ?", "%#{params[:search]}%"], :order => 'updated_at ' + params[:sort])
      end
      @status = 'all'
      @statusname = 'Show All'
    else
      if params[:search].nil?
        @bounties = Bounty.where(:status => status.to_i).order('updated_at ' + params[:sort])
      else
        @bounties = Bounty.find(:all, :conditions => ["status = ? and problem LIKE ?", status, "%#{params[:search]}%"], :order => 'updated_at ' + params[:sort])
      end
      @status = status
      if status == 1
        @statusname = "Show Claimed"
      elsif status == 0
        @statusname = "Show Unclaimed"
      elsif status == 2
        @statusname = "Show Completed"
      end
    end

    if !params[:search].nil?
      @search = params[:search]
    else
      @search = ""
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
    @bounty.update_attributes( :status => 1 )

    if @bounty.save
      redirect_to @bounty, notice: 'Bounty successfully claimed'
    else
      redirect_to @bounty, notice: "something got messed up"
    end
  end

   def removeBounty
    @bounty = Bounty.find(params[:id])
    @bounty.user_bounties.find_by_user_id( current_user.id ).destroy
    if ( !@bounty.isClaimed? )
      @bounty.update_attributes( :status => 0 )
    end

    if @bounty.save
      redirect_to @bounty, notice: 'Bounty successfully unclaimed'
    else
      redirect_to @bounty, notice: "something got messed up"
    end
  end

  def completeBounty
    @bounty = Bounty.find(params[:id])
    if current_user.id == @bounty.users.find(:first, :conditions => ["owner = ?", true]).id
      @bounty.update_attributes( :status => 2 )

      if @bounty.save
        redirect_to @bounty, notice: 'Bounty completed!'
      else
        redirect_to @bounty, notice: "something got messed up"
      end
    end
  end

  def uncompleteBounty
    @bounty = Bounty.find(params[:id])
    if current_user.id == @bounty.users.find(:first, :conditions => ["owner = ?", true]).id
      if ( @bounty.isClaimed? )
        @bounty.update_attributes( :status => 1 )
      else
        @bounty.update_attributes( :status => 0 )
      end

      if @bounty.save
        redirect_to @bounty, notice: 'Bounty marked as incomplete!'
      else
        redirect_to @bounty, notice: "something got messed up"
      end
    end
  end

  def vote
    @bounty = Bounty.find(params[:id])
    @vote = @bounty.votes.find(:first, :conditions => ["user_id = ? and bounty_id = ?", current_user.id, @bounty.id]) || @bounty.votes.build(:user_id => current_user.id)

    oldValue = @vote.value || 0

    vote = params[:vote].to_i >= 1 ? 1 : -1
    @vote.update_attributes( :value => vote )

    voteChange = vote - oldValue

    @bounty.update_attributes( :interest => @bounty.interest + voteChange )

    if @vote.save and @bounty.save
      redirect_to @bounty, notice: 'Interest updated'
    else
      redirect_to @bounty, notice: 'something got messed up'
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
