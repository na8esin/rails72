require 'rails_helper'

# あるクラスが依存しているクラスのnewを通過する引数を検査したい時のサンプル
# newはクラスメソッドなので、クラスメソッドをスタブするのどうやるんだっけ？というのがスタート
#
# 前提知識:
#   pure test doubleとpartial doubleと言うものがある
#   そして、`and_call_original` is only available on a partial double.
#
# 断片的にコードをブログに載せるときは、described_classだとわからないので、あまり使ってない

RSpec.describe User, type: :model do
  fixtures :users

  # こんなcontrollerのメソッドがあったとする
  def index
    users(:morning_man).fetch_external_with_initial_value
  end

  it 'newはクラスメソッドだからclass_doubleを使う？' do
    class_double(ExternalApi).as_stubbed_const

    # #<ClassDouble(ExternalApi) (anonymous)> received unexpected message :new with ({:greet=>"Good morning"})
    index

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end

  it 'ExternalApiのnewとfetchを補った後で、as_stubbed_constする' do
    class_double(ExternalApi, new: instance_double(ExternalApi, fetch: 'hello')).as_stubbed_const

    # #<ClassDouble(ExternalApi) (anonymous)> received unexpected message :new with ({:greet=>"Good morning"})
    index

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end

  it '依存しているクラスのnewをスタブ化して、newの引数を検査する' do
    # これだけで、partial doubleになるし、fetchメソッドもそのまま
    allow(ExternalApi).to receive(:new).and_call_original

    index

    expect(ExternalApi).to have_received(:new).with(greet: "Good morning")
  end
end
