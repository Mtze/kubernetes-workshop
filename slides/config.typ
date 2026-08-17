// Workshop deck configuration.
//
// Every institution-specific value lives here so the deck can be reused
// unchanged against any cluster. Two ways to configure:
//
//   1. Edit the `default` variant below (what a fork ships with), or
//   2. Add / pick a named variant and build it with:
//        typst compile --input variant=tum slides/main.typ
//
// The active variant is layered on top of `default`, so a variant only needs
// to list the keys it changes.

#let _variants = (
  default: (
    institution: "Your University",
    group: none,                        // sub-line under the institution (or none)
    presenter: "Instructor Name",
    logo: none,                         // e.g. image("assets/logo.svg", height: 1.1cm)
    accent: rgb("#F28C00"),             // theme accent colour (workshop orange)
    cluster_platform: "Rancher",        // the management UI students log in to
    cluster_url: "rancher.example.edu", // where they download their kubeconfig
    account_wording: "your university account",
    ingress_base: "pedelec.example.edu", // <student>.<ingress_base> resolves to their app
    namespace_convention: "<your-username>",
    image_registry: "ghcr.io",
    image_owner: "mtze",                // images: <registry>/<owner>/pedelec-<service>
    show_registry_appendix: false,      // include the private-registry / imagePullSecret appendix
  ),
  // Example override used for the TUM delivery. Copy this block, rename it, and
  // fill in your own values to make a reusable variant for your institution.
  tum: (
    institution: "Technical University of Munich",
    group: "Applied Software Engineering",
    presenter: "Matthias Linhuber",
    cluster_url: "rancher.ase.cit.tum.de",
    account_wording: "your TUM ID",
    ingress_base: "pedelec.k8s.ase.cit.tum.de",
  ),
)

#let _selected = sys.inputs.at("variant", default: "default")
#let cfg = _variants.default + _variants.at(_selected, default: (:))
