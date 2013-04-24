class Authenticated::BaseController < ApplicationController
  layout 'authenticated'

  before_filter :authenticate_user!
end
