class Office < ApplicationRecord
  belongs_to :city, primary_key: :city_number

  def self.keyword(keyword) #ここでのself.はOffice.を意味する
    if keyword
      where(['name LIKE ? OR address LIKE ? OR company',
              "%#{keyword}%","%#{keyword}%",   "%#{keyword}%"])
                    #検索とoffice_name,address, business_entityの部分一致を表示。#Office.は省略
    else
      all #全て表示。#Office.は省略
    end
  end

end
