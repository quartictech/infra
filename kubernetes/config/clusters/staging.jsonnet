# TODO - switch back to camelCase once we eliminate all the YAML dependents
{
    require_confirmation: false,

    gcloud: {
        project_id: "quartic-staging-79680f42",
        cluster_name: "staging",
        zone: "europe-west1-b",
        static_ip: "35.189.193.108",
        domain_name: "staging.quartic.io",
        docker_repository: "eu.gcr.io/quartic-global-c39fc822",
    },

    backups: {
        bucket_name: "backups.staging.quartic.io"
    },

    www: {
        basic_auth_enabled: true,
        default_website_tag: "staging",
        formistry_version: 17,
    },

    platform_version: 2928,
    quartic_python_version: "$QUARTIC_PYTHON_VERSION",

    jupyter: {
        version: 100,
        analysis_bucket: "analysis.staging.quartic.io"
    },

    postgres: {
        version: "9.6.5",
        password_encrypted: "1$34ea8ecbac4cf47f664b37e5$b31171c9c90f973e$5d51c5eaeaa8d562c43e8acdbcd86ff7",
        password_plaintext: "dilectic"
    },

    aws: {
        region: "eu-west-2",
        access_key_id: "AKIAI63H3LDIHH6HFUXQ",  # Associated with the platform-staging user
        secret_access_key_encrypted: "1$f8eb7b26c71799eb8bf88c28$c7257a5fe7c3d9c1135344f1e93cd7ec084e3e40b69c59ce468b0a05015c51b27e77d9a959296314$54fe3470e3923f89054181f643f4db14"
    },

    github: {
        client_id: "20b3b7294d1d8db9731e",
        client_secret_encrypted: "1$a421a7cf0e787f0499ccf464$7bf4c1222f17cb86a28c5bfa33cbbdf8d17ceec10dd5385a47132c2148d14570913d5e8132c419f7$cb69a1e3744c51b65c7a9354c5c75d90",
        app_id: 5342,
        webhook_secret_encrypted: "1$fa36a37eac32e5720536f881$0afb013ca8f14f3aa96d9c75368dfce49d343fb5$cf97346081ae5ab5f55ac01d03b77c66",
        private_key_encrypted: "1$ac84eadeaf573e54f936b8bc$38068f48b4c3c3c0ad07a506f170d45ae075e928d07246edf143be83c15fc7162fac4586e8df0fe3a6ac5e53c6d61b85c4d6343b1bda3f859e0c43d73cda4fe1051948434d26fc323d3e5a258af4287556775a0a19f832a9a3b7e32f5413d52a91ce9857a4402c0d290488723ac72e8e9ba9290c4eedb9452c2f94230115d52feca563fe6e3295977bde38c53346e83e0b99e47a0245158b2efb87bd91d50e5bc0bafddcc35deaf461214648e6287278713b15d1571f6db09132ed4a71d536d2eb38a89139d678818fed73664c1eff6db17144eb70d49dff85b0c234bfe320aedb1318fb842c6ae77ebea4c7429bac9cdf26020c769e837eeb9c4a46b70ebdb05a6ad2e40b2c59ef5e9136c1327bd62ba682d319aea41eb47f57c37a21c6ad64a1c29c211a32edd83f64c66ecf0be28e7a21dca3d09bd030b315b541501aa18b05502abe1730b590aae280d8e76bf3caabf96ac5301bb81cf845ec0956fc50845e08ccbfc38e141565b188b1871d4f11260a64ac2eb2eaac8adbe733a613690cb142ef05a5e0003cdd990fc311a582200e0ff1e1f5778e1afa9a3e4be1ee9bac055974227c6b7028c47cf70ef3a2008c4faaea54f0cbbb6145ef6bf256d6fefe187120865bb3cb6d9bb0defae827e1a21efe07457006e7df52e7b6abc81f83f9bee7eae037e9a1f6a7281827d9ea6921d8682b462b48fb667b886c22a921356924d9e5eb8c905f3865f743eca94830db12b75f42f1a90c7803909c3368e49e98359db8bba6c88283bdadc2da6747e0e3c6c723caddb3d14c7bcaebc6ba63334628ed62323bf58e225460d1cf59743a9149cf76b93a6935b4b7c0f120a015d9f14f97cbefc0561abc141d72cf938be9bf8768950e11af00aca8afa1cb20e86e867d5bd673f64650bc038d3d91d71552cb099a4a1fce6a9aa85a5a0ea513af9283aba800fd041ce267531596acfa1f62c52536701577fa12f2af0e8dc072b2a7f1e93f24761f3c0c748fb3a3d0aeba58dc65fa12b04512062619bceba3eb45cdde905524768af92c17fc4befd1c89eac2a08c97d20703b8f852193db3945a42f3c48a8c7d7b969d3f3d589fc1ad10d66acaae3438805c859de1f70a07e95116f583e08d83dc9db9b0afa9fbb8bc9d9a8073dd7c7d5667aed5f8be9e7794e8ff3ab7b4b1f06e55f45436450487495210a28ac6e16cba38e7520332f6f106c01e18e2bd7bc1472659727cfc17088da53805a9422bc358f672056ee2778317384a29fd054bbefaa2dc6dd05adc6c188bd562c1b9bb701df56290ec16cb5d923ab0fe8c0e2c11f3264f925fbb15aeeb76be85175e0cbbee346cb6e1980bd069e5eac0564c38239ef247014d6d2b670ef2bf7e5075d4994056c40dfbb7e046edbf89a7e34bd31b7c69931ae6f50f77cd7fca11b081b0942c55d1b4bb6240047788445cf11af796756c62c292a41c3ad21c96b4c1046222d453af92a9ba379861475936a710a2ecbe239a99b14c8131397769db72689beb7dba0360207c4867a362f10dc99dbdcf63a8807bce814ef1bb9487c3c393539d331d9d5eeb66cab9e0b0691979638563c61b856f878ce7a49f8e43b921e1d62a6df6efd112ad6c45e649ab8bd4e98db61e9f52874051dd4dac0b733fd5d53a74ee794bb9145b90c9608d6db658687058c96de42d7ee79c35b5b0cfc158753f7b75aa8c2c214b58eece8f38d8de7616779f66e9fbafddf66fab9e42d887a45c22d00786418d2d0551eadb2231b77d35ec7aa6a52bd47486343584c115f802b090d22cec10a105fbbfb7e412f7ea17666b166ba03a8ce9dfdf4b20d1d9bb434b964ac111e79e9e9dfd783dd9f3fcc1eafb167ca9a4094081286169b9c31c16185fbde065eaf49710e265127d2a1f8c04cde7b659c962e3a70e9f448b354192fd56c399b623a5b2b05fbdc8e2e895465bf191cc0623d17eb833c934d25c7004aa68b9fe091bb736e6e7ef1511ca0c6e5a1497ad29564a58df10444864b844bc22a878c9b9346e778715b5ea6e8eca3d388a139a7ac523d03e4968c15bb40aa08428279e330ba114b8c8344c41e246176d7b5ff8a691f7da64a747bd355906776bade0dac3dcbbf7065e4cb2c8b361c8e2e0b8b2f0e89261631e70c2e22f07f89ded91ee87d74fda369a3e0accbba80bbf51997c095582183942f1277c1066c7cdb4b99dcd45342460514dbd9beb4e0c528b5367dfe658b57c76f69a0879084469b607c1ee3111cd61940cb364048c354514f1ae5bf0f3b218fda0825d9c2ac90b0de6beef7c6e4d887163c354c33c3c5c6333d31c7a9a632591d11eb1d63c03263921c75$a51ac5af8b93c3e92915a40cac2ee9ea",
    },

    slack: {
        username: "Quartic Hey (Staging)",
        default_channel: "#pipelines-staging",
        token_encrypted: "1$5bd3fdf36ede55771d526900$4ceb1b730ec90548e2bb8182b3aa0a8a6aab108006ede272d315d0cc4339f6886ff589885e00c909c9080f52$fb39c510411ff0da0e6ab01e067e84e9",
    },

    token_signing_key_encrypted: "1$8cb8d49e9ab56a56954b406a$8fcf6405f06b5c962602fdccf9c2c00b2f6ae0161c4e4d3ce8155d46fb01f16b1eab5d1446f823ac2dbd74f80ae9f557cb64e43a1c6b9a8b82748005a04ae56a2b10d09b0a503ca81ea01906f119dab079649429dfa54257$e55515f4392896321dd6ecca03dd05d6",


    #-----------------------------------------------------------------------------#
    # Customers
    #-----------------------------------------------------------------------------#
    customers: [
        {
            registry: {
                id: 222,
                name: "Hammer",
                subdomain: "hammer",
                namespace: "hammer",
                github_org_id: 22931189,
                github_repo_id: 104074994,
                github_installation_id: 54057,
            },

            howl: {
                type: "gcs",
                bucket: "hammer.staging.quartic.io",
                credentials: {
                    type: "application_default"
                },
            },
        },

        {
            registry: {
                id: 223,
                name: "Quartic-Python",
                subdomain: "quartic-python",
                namespace: "quartic-python",
                github_org_id: 22931189,
                github_repo_id: 100040858,
                github_installation_id: 54057,
                execute_on_push: true,
            },

            howl: {
                type: "s3",
                region: "eu-west-2",
                bucket_encrypted: "1$d6dbb1201bde4c2023d1d97b$d1e59a8fff88aea45c279864ecc3d3553f05135b1ac1b06588$4a8e7115df660b1d3d35e567e7edc7eb",
                role_arn_encrypted: "1$6ed082e1e30e3a2508bb96a9$cfc763154d8bc8a3463efc5c493044e6daea01980669bc65e8d52ca08abcba84410449a8e11885b314d40d62037bf6d4623775cbe752ab3f13$07fe50e9880c6fd887af744f61a544ca",
                external_id_encrypted: "1$c63edcbf01b01b1f5b799456$a77037e47cee37579579e869cd4f22a379710fa563148fe6dcc7427fec573c042d2ff4ed$e139fe08d859629afd56f93666aa2780"
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
