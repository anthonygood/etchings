class EtchingsController < ApplicationController

  EXHIBIT_ORDER_BY_ID = [
    20,
    37,
    5,
    6,
    47,
    48,
    25,
    11,
    13,
    14,
    15,
    17,
    18,
    19,
    22,
    23,
    26,
    27,
    30,
    32,
    33,
    36,
    43,
    45,
    50,
    51,
    53,
    54,
    55,
    2,
    8,
    10,
    31,
    28,
    29,
    16
  ]

  def index
    @etchings = Etching.all
    @themes   = []
  end

  def show
    # @etching = Etching.includes(:prints, themes: [etchings: :prints]).find params[:id]
    @etching = Etching.all[:id]
    # @themes  = @etching.themes

    @next    = Etching.next @etching
    @prev    = Etching.previous @etching

    redirect_to :etchings if @etching['unlisted']
  end

  def exhibit
    @etchings = Etching.all
  end

  private
  # def exhibition_order
  #   all_etchings    = Etching.listed.includes(:prints, themes: [etchings: :prints]).all
  #   best_etchings = all_etchings.index_by(&:id)
  #                                 .slice(*EXHIBIT_ORDER_BY_ID)
  #                                 .values
  #   rejects = all_etchings - best_etchings
  #   best_etchings + rejects
  # end
end
