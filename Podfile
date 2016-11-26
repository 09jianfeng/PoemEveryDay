platform :ios, '8.0'
use_frameworks!

def share_pods
    # 网络
    pod 'AFNetworking'
    pod 'SDWebImage'

    # 工具
    pod 'Aspects'
    pod 'AutoCoding'
    pod 'KVOController'
    pod 'RegExCategories'
    pod 'YYModel'   

    # 调试
    pod 'CocoaLumberjack', '~> 2.4.0'
    # pod 'FLEX'
    
    # 数据管理
    pod 'CocoaSecurity'
    pod 'Realm'
    pod 'SSZipArchive'
    
    # UI
    pod 'FDTake', '~> 0.2.5'
    pod 'JazzHands'
    pod 'Masonry'
    pod 'MJRefresh'
    pod 'NYXImagesKit'
    pod 'pop'
    pod 'RESideMenu'
    pod 'FDStackView'
    pod 'DGActivityIndicatorView'
    # pod 'UITableView+FDTemplateLayoutCell'
    pod 'YYText'
    pod 'MBProgressHUD', '~> 1.0.0'
    
    # ShareSDK
    # 主模块(必须)
    
    inhibit_all_warnings!
end

# Target for App
target “PoemEveryDay” do 
	share_pods
end


def share_test_pods
    pod 'Expecta'
    pod 'OCMock'
    
    inhibit_all_warnings!
end


# Target for Unit Tests
target “PoemEveryDayTests” do
	share_test_pods
end





