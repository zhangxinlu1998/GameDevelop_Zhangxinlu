using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI : MonoBehaviour {
    // Start is called before the first frame update
    public GameObject Character;
    public Slider slider01;
    public Slider slider02;
    public Slider slider03;
    public Slider slider04;
    public Slider slider05;
    public Slider slider06;
    public Slider slider07;
    public Slider slider08;
    private Material mat ;
    void Start () {
        slider01.onValueChanged.AddListener (OnSlider01);
        slider02.onValueChanged.AddListener (OnSlider02);
        slider03.onValueChanged.AddListener (OnSlider03);
        slider04.onValueChanged.AddListener (OnSlider04);
        slider05.onValueChanged.AddListener (OnSlider05);
        slider06.onValueChanged.AddListener (OnSlider06);
        slider07.onValueChanged.AddListener (OnSlider07);
        slider08.onValueChanged.AddListener (OnSlider08);
        mat = Character.GetComponentInChildren<MeshRenderer> ().sharedMaterial;
    }

    // Update is called once per frame
    void OnSlider01 (float value1) {
       mat.SetFloat ("_OutlineStrength", value1);
    }

    void OnSlider02 (float value2) {
        mat.SetFloat ("_TileFactor", value2);
    }
    void OnSlider03 (float value3) {
        mat.SetFloat ("_lightRange", value3);
    }
    void OnSlider04 (float value4) {
        mat.SetFloat ("_ShadowSmooth", value4);
    }
    void OnSlider05 (float value5) {
        mat.SetFloat ("_ShadowAlpha", value5);
    }
    void OnSlider06 (float value6) {
        mat.SetFloat ("_ShadowOffset", value6);
    }
    void OnSlider07 (float value7) {
        mat.SetFloat ("_lineRange", value7);
    }
    void OnSlider08 (float value8) {
        mat.SetFloat ("_lineAlpha", value8);
    }
}