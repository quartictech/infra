{
    require_confirmation: true,

    gcloud: {
        project_id: "quartic-prod-5df2e1f7",
        cluster_name: "prod",
        zone: "europe-west1-b",
        static_ip: "35.195.96.231",
        domain_name: "quartic.io",
        docker_repository: "eu.gcr.io/quartic-global-c39fc822",
    },

    backups: {
        bucket_name: "backups.prod.quartic.io",
    },

    www: {
        basic_auth_enabled: false,
        default_website_tag: "prod",
        formistry_version: 17,
    },
    
    platform_version: 2886,
    quartic_python_version: "0.6.0", #"$QUARTIC_PYTHON_VERSION"

    jupyter: {
        version: 110,
        analysis_bucket: "analysis.prod.quartic.io",
    },

    postgres: {
        version: "9.6.5",
        password_encrypted: "1$93d02a3a074e5b6839703c00$bc0f9cfcad88457d$86e831ebece740d9c836878ab6588099",
        password_plaintext: "dilectic",
    },

    aws: {
        region: "eu-west-2",
        access_key_id: "AKIAJ4GVRONMW44PM22A",  # Associated with the platform-prod user
        secret_access_key_encrypted: "1$c61f591ccf5f25df9ba8d087$a0dfb5003e528ae6ec3cb06a395c0e8974e068c7a9454e79fa2d5aa0dc30039b15d2a8153b8d735f$7cd8d4d3faa1fa8464ebeb4a5c7620d7",
    },

    github: {
        client_id: "ab6d4546d3895f750518",
        client_secret_encrypted: "1$d516f7ac83a674bc31240262$8d3369b4e8e89406fc8148bbadb1056c66d88dfe4c8b2370770f74b887ebe2d94d145de0f4bbfd2b$36167a5f8e430745ede571cb68e7a7ba",
        app_id: 3853,
        webhook_secret_encrypted: "1$c14d6f058f79a47e898a3716$1a8a2d4c09cf8c3a6ed2d171df01684abafd12d6$8fe567ac8e766a3a89d74d46fca33c69",
        private_key_encrypted: "1$d364138555dd048e1b43eafd$95bef2e04d2bcab110070c3cb7db09653e3e4cbca128e42500a7c4692daf3d251ee598d2d5ac44fb92cf56dfce2b3f46cbca819a572f640016d9e0e0d460272350c869c270b0e107b7469603cf549407232d5c159d732b493807a5eb684e1297d5e584a4bec749ea0a9b8e17a59b20bff843430d518faaf55cb571dd8bcdd247cb3fac2b55bb94e493c70f0d399cf1849b2decdb3a63f5c191054ae52b1abde551e0a16dd1cb50d4481b2286fa7d68c91d9591835d802e558d100f1fd3d13e519518ecfcba2ce198991a45913254abc6e9443ff47776d62e3ac6f6cd54e3784a19b2b025ef86d131acadb663907ba1a383f85a6da9f0cb7c75f3a23b307f0929043539711f275f8b66aa0b9e1ea2dcbe9e8d076f5f9565698025b4cc85347a3dd45ee10ef00af21efbc86403c7f762581b30df7c940b3fb2fdbd72e0e390244e77e40a416f7eadbe8e6b4b048c46257f65b2726d0ae64c934deaa32f5bd451a55ed55cf4f11dd728f66e365c87753aa040f45abf73b9138babdc2276bf8b941a37ca44866c19719d69bf32534eda969a9a024a851a8509d31256f4997ac6e563e371a5eb0b9d546d051292d6b875808701d5e7d622dc249cabd3fff8c776dedb40c9b3266374495c47f0828d2f16b9eecef6130822b8d5517f23dbe7059440f59907c459dcf434f11dd5122631f9f446b42354e6b8665aa56ba623b9e9d687df976d71e6bb3257e6ad329104d8a9dce80d5b8db1176e8e1192714f19424c67a77d87f7f1856183e8017be1e252ff66bf6a225a00b41f9f4796180e3b4a2ab63ca091ab8e0a71a7ba3383524113c93dde6ca5dd2b59997bcc5b8ad6dbe5e49a285d9f21fac2e8591f7b4ede78c8bdd404ecde307fef4c8ba52b3306a1278a5589f4605f0cf65eb4c6e2b9a95a72ec2a5a35ceb38f7ad789798dc3573c747f73f84caf1e3f8ef9473a870fa0f8c2f1a9d6ac5bf70d18939289ed6ca39e254e731fa24bea37df776c3fbce9077e0dafaa780def9fde8c99c9ab56aa7348d51bb04efe0c00cf2e80ab49e45bec487c7943af1c743608d0e275815addf619283f0de87d722f5d6baa02f551406fe92d143d97e8bd4789125f348a531140f78424182d86d4138bc0fe2e25713e5e73ea3b124a55926e7aae1bd7a175408ab6d32909bfb8c54536c62e67db51fff6bdb9d9d96c027ead84e3406028526e5ff10a202c45a483e5e044c95eec1987fe18d6bab1aa1547f1ce464a81f00c389ce2e66a6371ec31dfc2d98b4895f323b58266ab8866357e36b13e22afbd4a14874adaa299ddb4e4cdf0976fd780c3e6165a73fc6bd319d1fe4c6d98ddb7130492ead5c20878b7749ee96deb4fc8ecd86201c6ff13c128f771b462da87bf8b9a259c7654b57c6032370e8a6b309f66266733a50417030a0d6a51ad9efb1d8cd2b0922f0237006c0898c19f4a7c89dcf84ce7fc2d5a3d0d52976ceb6e5ddeb865e78b73bde7b09dba93b342defea9d0fa490171c9f12a1ee8b71d50900ac5f6aeb8c2b36f5c2479b3021f33a9bbfa089ef98080015ca1ca76ca13ac9670cc4e1fbd9050dd8c91726a66ed49eba1f5777accb75050516a75db46ed8a283264d84403fea82fe208e2922cae19586b1b3af11f5c125c502128f84fe465430ccd5cecc4f0e335d0453f2f7e58416549edf4b3f15ea010cb8ea3fa9d3c9fed21e29ed36bea2d8118c2443ecf08bf3f23b04963e318acebb08c30a40999e2d63210fab1f7b978d5f6542282f189e45fef9fc0d01c7deeb7323e3367c95a13d1654d991f9c70c90611976f930d537874001145eb8e5d4b4d6d21b2ae1663a4104e8caf03ac3cc75ca11c877d4469b6d50099db1eb5c4375946b000d13017499be30c951b733159338d94ac9b9410a9e387d77dea508c9ce523b91524c696a45a2388ffabaee97f75fa0f09ac03d428bb1395c40d0e23af073447fa1508644e62b08007410bf5c418c4e6fa8d2e1a1e572c6a5fb49b4195db66f4ff1f92d0a59d94439dcf7aaabe81d20dcf6204da3999985af08c0054110ac674b3745e6d39c277880e57c76e49c14ef58412648ec2c147046d6fac5300f89102537700f804e9e935b31224ad2b1aeeebf3386b9ea1c0499ac08402c96c8f70c2e529d6ac9bcf892339ab717a9109c85b4536418c2312a2a9b4573049bd0c81bd49f7889259a9ec5d19c8c55d46e81003528c7aa60905e85d5f9c18a474fbcfacee403ccde5a166c620287016be138b8fca1d914ab89afbf8357b61dc6413502ed977fcbad7054b573ae8b67990baf20fdbd92819206c76fffc724e5bed18784777f2$b464c6ff68ed1d4d3a458a40f09c8c11",
    },

    slack: {
        username: "Quartic Hey",
        default_channel: "#pipelines-prod",
        token_encrypted: "1$5d1ff3377a2ba3eb2ce7d0aa$a778530d8ec1533775c2ebd1031c9f012b98812a9b1d4570bcde11ebf5c2819cc09fd14495d369978bb12dcb$2035281e77f5ae2b620cefe2914251d6",
    },

    token_signing_key_encrypted: "1$2969f6d34d7486797acf1329$831d47ec4a3eb179a9bce5879d323acdbc20d19547135d9b5ca9c54e2e9b810c86c09567722a59411b7c3da74d28b03c1bb9c1036eec3050596c6542139498ed6c49447f877f4aedb082a19a6c609156de3fbf8cfc6fb62f$dd9a939f9ef26978f0f7248c257a7704",


    #-----------------------------------------------------------------------------#
    # Customers
    #-----------------------------------------------------------------------------#
    customers: [
        {
            registry: {
                id: 112,
                name: "Magnolia",
                subdomain: "magnolia",
                namespace: "magnolia",
                slack_channel: "#dozers",
                github_org_id: 22931189,
                github_repo_id: 78424428,
                github_installation_id: 40737,
            },

            howl: {
                type: "gcs",
                bucket: "magnolia.prod.quartic.io",
                credentials: {
                    type: "application_default",
                },
            },
        },

        {
            registry: {
                id: 113,
                name: "Playground",
                subdomain: "playground",
                namespace: "playground",
                github_org_id: 22931189,
                github_repo_id: 99951423,
                github_installation_id: 40737,
            },

            howl: {
                type: "s3",
                region: "eu-west-2",
                bucket_encrypted: "1$9dd976db21f562cac8ea0262$0de686fe1d80380c4dc4d888e86a52087b57a64059$66904f39c822129ec39f861cd1d8768d",
                role_arn_encrypted: "1$b23c04cd6b2dcc9b6ead05c8$015eb67e019ae9221762f599f7b078142ab799e32c5aefd964b57f6aa953505205ce0eb12eb3040bd68a4a32f590bf84aa45b0e6ce03f173$2a363ced74268305b2e706278cbaf898",
                external_id_encrypted: "1$b97a16fd8607a30b63113d87$b90cbc9b560ea987233ed6469331a35cd89f70fdb9e9c6124acb0861cfd919591e2db9b8$d68e9ed2a7387a3b1b827df77d28f009",
            },
        },

        {
            registry: {
                id: 114,
                name: "Dilectic",
                subdomain: "dilectic",
                namespace: "dilectic",
                github_org_id: 999,
                github_repo_id: 999,
                github_installation_id: 999,
            },

            howl: {
                type: "gcs",
                bucket: "demo.prod.quartic.io",
                credentials: {
                    type: "application_default",
                },
            },
        },
    ],


    #-----------------------------------------------------------------------------#
    # Fringe configuration
    #-----------------------------------------------------------------------------#
    fringe: {
        stacks: {
            demo: {
                zeus: {
                    datasets: {
                        assets: {
                            pretty_name: "RSL assets",
                            url: "http://howl.platform:8120/api/dilectic/managed/demo/zeus%2Fzeus_roads_clean.json",
                            indexed_attributes: [ "RSL", "Road Name" ],
                        },
                        jobs: {
                            pretty_name: "Jobs",
                            url: "http://howl.platform:8120/api/dilectic/managed/demo/zeus%2Fzeus_jobs_clean.json",
                            indexed_attributes: [ "Number" ],
                        },
                        insights: {
                            pretty_name: "Insights",
                            url: "http://howl.platform:8120/api/dilectic/managed/demo/zeus%2Fzeus_insights_clean.json",
                            indexed_attributes: [ ],
                        },
                    },
                },

                auth_secret: |||
                    admin:$apr1$gH1mEO/e$WVAD6tU4dfzzzaxFOpaoz1
                |||,
            },
        }
    },
}
