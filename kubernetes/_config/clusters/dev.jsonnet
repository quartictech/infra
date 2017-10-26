{
    require_confirmation: false,
    dev_cluster: true,

    gcloud: {
        project_id: "quartic-dev-d07891a1",
        cluster_name: "dev",
        zone: "europe-west1-b",
        static_ip: "35.195.64.171",
        domain_name: "dev.quartic.io",
        docker_repository: "eu.gcr.io/quartic-global-c39fc822",
    },

    backups: {
        bucket_name: "backups.dev.quartic.io"
    },

    www: {
        basic_auth_enabled: true,
        default_website_tag: "staging", # Deliberately use staging here (rather than dev, because that's not a tag that we build)
        formistry_version: 17,
    },

    platform_version: 2886,
    quartic_python_version: "$QUARTIC_PYTHON_VERSION",

    jupyter: {
        version: 100,
        analysis_bucket: "analysis.dev.quartic.io"
    },

    postgres: {
        version: "9.6.5",
        password_encrypted: "1$3a79c4ab7ca1feb0ec34c1b7$f15b525993d272db$5b90792fc42454f92b96b72c96269d40",
        password_plaintext: "dilectic"
    },

    aws: {
        region: "eu-west-2",
        access_key_id: "AKIAJMHQEI6JCXMYWHGA",  # Associated with the platform-dev user
        secret_access_key_encrypted: "1$53d59cfa9bd7191674f3a8b8$bdd388baad8788e04fbb5e72e71500ffaf9300760dc8226c4562ff6fe4175762198be928d041a87e$fedd38718128a3d96a6de3accba1217b",
    },

    github: {
        client_id: "af4a5c01c7850fa04758",
        client_secret_encrypted: "1$a53816bc3f1bfa4ffa915632$21626e930d51a932116f9ae6bef1b82a4ac57a24aabcb5995b507048e66e0c9ca60239b2dc3f7d49$f80d3b7df9273685a4008b350b74d7a8",
        app_id: 4352,
        webhook_secret_encrypted: "1$750bce4cb6ce303cd178e305$2a27e18ace8b746083a087d0683f87e85964da70$f5123f534b44aadc2bb68b7e1bdc668a",
        private_key_encrypted: "1$5af92ff72056745c24a4218c$2776c09f5bb9316f99c6c0c6068d98e19b1c7632619991d10a10b050b3770513704fc20a72798397e679d51753a9dd62964e42ae7fd502ef235655ea52f43853c085d062912f40f51fb7c6f71a7e92c68a59f72a52537ad22610cfc84cb9fa4c01caca92ef7eb6afd395ca7d2431ffab98195470c0d5983713d32c44f4ad250f68fe8df185c8987aea205c3f25a07d04e86600c649410f4e7c37b3e609cdb2bc473c7601a16a80fc51396440975044ed338370e3c05904e242a65fe71403af8823ce952c01a68267d35666b7517059f2eb91d8d0843c277c7f0e99ac1eae542395dda8f43996048a71c8ff05277628d4adfa88bfbc4a819ea12511bba491cb7f2086202d25fd2e577862fd56443ae94e8eadccc3c32c64156d6df50084438badc905c85b55f303022dad0a5773d4e692e0afaf6cc3b03cc89cca3444d33482b891d717e04bd1e2e88c3c5fb22036889dbd13bc0e02644229cb3b7ef550c2ce21e828d0d99c9998aad941541709f1a070ead23fe01b37fb129a4896bbc1499976662776696c332cc32e40c765a1ed638237f226647a56ac2143fd72240f0ee81585ac259b9ae94d2230049572e5c10ab6b1c428b8e98f171d9efb6d08812b79cea1d8b7b9ef520806609ddd2b30aeeb6e3e6f9f485eb067dc5b89c98d104dd8cd0c636d591454719d587f81df5f9d18748257d3b138a7e31169cd17a93a5aa03d796a38757bb999341f985a6195c3c98c4b32571e895860e8f7939cf2346d6b8a4e4cecb43dd158c6afde02f5f4de8c42c60961d4b2ac2ecfb832355ea8853f48f1ed2cd4160bdf41486bcfc4e03637f3cc81e2fbdacadfd36b443659351e8fa64fd62c467e1e4bb4e0bc4b59a4afe6ad219df5df3225889f0a5083296b0e0f8eac358623491adc55701f234f1d2e83f89c00535ea4f416c27d82bcbd640b02ad1cc2ffd4f949610c0e1edd9bdef9fd1111bd139ccba3f381b8b7e7f151f78e89b0af4ca57eb0b650966dd3c377cbddc5ec781f49d91005528e6ea1917a2029c43047f28e2f80a6689c0c941f4f5100cf8fe75d2deb7cd00ed27e0f50113496b590a7b9bf7cf859c2c0183db656f02a1794e99816bd282337db266b536095dd5d001fcd6bdc8fcd1a6360bf29a63fccfb1af796ff4a9a29e492357f9afdcb12d5bb6e00ac18d80c064f63896e751fab7a8bf880f1e5ac2879177046c162b3a03f7b83087fd98240d0663cbd6d6c0a5f5a63837dfc33e374ad8fb190a68ed928ea3cb64775a775461cb3d3da910d6e8b105c868ba888aaa97b52ff6e7f1a391eaaaee53ef12fb2b8b48cb0106470ece65070371785b769070c268b5cf56326c1a82042184b51a61518dd730ca82b709e7a67679d458e37f1200cb4d47f1f20d15f9a322de2c9020d504a34539000b0836b9321c3ff5d0adf1dec071a69af673a7f93b0d98ec4a4448578a3b6fe0b34c18385380883c984022a6aa3a85f7585c77040f8363fbc833cd9baa4a5ef26f7f37aca87b2c363445406a8a3896440485af83cb211ffe1d92826eff087036153e16f2cfbbd5fc90738d4a59fa6ca73fda602a68f876f1911c64901d57f41c19ac3ecd59870296ee3c824bd6a566aa60254341a7f7ccf7b0c24652745d61de12dab2230926fe6088aff13bd031b1e5ab08583a4f8ef0286d6a298be8f4e24571fad2c339601ee437288521f7dc01ec852c4b3f8ce83f93011d674570f035e2bd244bef58c0c4a456e408ba0e91898031c2a5feb97c7b9258255ba2c4fc8c690d6125c15177d1e51a917b7be81d816c9936dca27d63703c5b19d9cf0e8a284c974a8ce0c23d1a61b46b5cd6356fc027281adb40179f81e7a0861c19901afc3d5da1ee3e7661cf6e0f8bba921313ce11560b3d2550076070ff7e08182b2ad5ae64cb41b5b425741fc9647f14ef73a12f1287ebe7714783301ad46d028f4fe19ef616c938bf5d76514ee60d87f5f4586c3f8ca6f5f02c5ca8f626689d26b957b53c3253656517b00b6841e168f2f17ffa4dd3471145c41348ba4ddd95426cd46a2c5d560b63b09128e55170d0bf4ca23b7766d72d4f5cbf6c93cbf183bd3e0a5e6744ef08508b6b24c7c75932d86bd3c0513cf1e0ff5b15e66443ff59f772f31249e7579e706f98b7897ac402c0240503592832282c2e476fb6ad6086143cc9dce2ef5bb439d882411d8643f6f0fb06a91bebad9c43b9addfdf7372ec144af5e534e62522b9126c29197a7d3e45c35bfba3ce0d1b644d1eed7968ae4bc0c8bef11801057e8104e56ffefe8410a50510e03a618399dcfdc4e53058258fd194e318c282c834a7b$d0d737ee9f9f5a5964d83bc7e80cab63",
    },

    slack: {
        username: "Quartic Hey (Dev)",
        default_channel: "#pipelines-dev",
        token_encrypted: "1$d6c950a99fcc8f28ab0dc7a6$7de9b988b297d4d6b575a95460cd17b4a248cd3d5ebfaeb795d7874fdc281d8b63d498f4c7bd20d2981615ce$31e36b4f4b0be1a5b2da47b39de74ad8",
    },

    token_signing_key_encrypted: "1$200ce236d8932bcfdad93bda$8a313bc418373b941f796c9e0011668b669f91616409654851018eb0d8683c867184c7a78c254e67574d490581b0d32426ea314deb785313b46fc41c17ccc2d175bc85f94b5863fa1dbaad2bf04e501c2e4ad2b03e9fccbf$863ca1668d67a58d6590f1849df8e62d",


    #-----------------------------------------------------------------------------#
    # Customers
    #-----------------------------------------------------------------------------#
    customers: [
        {
            registry: {
                id: 222,
                name: "Noob",
                subdomain: "noob",
                namespace: "noob",
                github_org_id: 1234,
                github_repo_id: 5678,
                github_installation_id: 4321,
            },

            howl: {
                type: "gcs",
                bucket: "noob.dev.quartic.io",
                credentials: {
                    type: "application_default"
                },
            },
        },
    ],

    #-----------------------------------------------------------------------------#
    # Fringe configuration
    #-----------------------------------------------------------------------------#
    fringe: {
        stacks: {}
    },
}
